<?php

class FileProcessor {
    private $file;
    private $threadsCount;

    public function __construct($file, $threadsCount) {
        $this->file = $file;
        $this->threadsCount = $threadsCount;
    }

    public function process() {
        $chunks = $this->getFileChunks();

        $futures = [];
        for ($i = 0; $i < $this->threadsCount; $i++) {
            $runtime = new \parallel\Runtime();
            $futures[$i] = $runtime->run(
                \Closure::fromCallable([$this, 'processChunk']),
                [
                    $this->file,
                    $chunks[$i][0],
                    $chunks[$i][1]
                ]
            );
        }

        $results = [];
        for ($i = 0; $i < $this->threadsCount; $i++) {
            $chunkResult = $futures[$i]->value();
            foreach ($chunkResult as $city => $measurement) {
                if (isset($results[$city])) {
                    $result = &$results[$city];
                    $result[2] += $measurement[2];
                    $result[3] += $measurement[3];
                    if ($measurement[0] < $result[0]) {
                        $result[0] = $measurement[0];
                    }
                    if ($measurement[1] < $result[1]) {
                        $result[1] = $measurement[1];
                    }
                } else {
                    $results[$city] = $measurement;
                }
            }
        }

        ksort($results);
        $this->outputResults($results);
    }

    private function getFileChunks() {
        $size = filesize($this->file);
        $chunkSize = $this->threadsCount == 1 ? $size : (int) ($size / $this->threadsCount);

        $fp = fopen($this->file, 'rb');
        $chunks = [];
        $chunkStart = 0;
        while ($chunkStart < $size) {
            $chunkEnd = min($size, $chunkStart + $chunkSize);
            if ($chunkEnd < $size) {
                fseek($fp, $chunkEnd);
                fgets($fp);
                $chunkEnd = ftell($fp);
            }
            $chunks[] = [$chunkStart, $chunkEnd];
            $chunkStart = $chunkEnd;
        }
        fclose($fp);
        return $chunks;
    }

    public function processChunk(string $file, int $chunkStart, int $chunkEnd): array {
        $stations = [];
        $fp = fopen($file, 'rb');
        fseek($fp, $chunkStart);
        while ($data = fgets($fp)) {
            $chunkStart += strlen($data);
            if ($chunkStart > $chunkEnd) {
                break;
            }
            $pos2 = strpos($data, ';');
            $city = substr($data, 0, $pos2);
            $temp = (float) substr($data, $pos2 + 1, -1);
            if (isset($stations[$city])) {
                $station = &$stations[$city];
                $station[3]++;
                $station[2] += $temp;
                if ($temp < $station[0]) {
                    $station[0] = $temp;
                } elseif ($temp > $station[1]) {
                    $station[1] = $temp;
                }
            } else {
                $stations[$city] = [$temp, $temp, $temp, 1];
            }
        }
        fclose($fp);
        return $stations;
    }

    private function outputResults($results) {
        echo '{', PHP_EOL;
        foreach ($results as $city => &$station) {
            echo "\t", $city, '=', $station[0], '/', number_format($station[2] / $station[3], 1), '/', $station[1], ',', PHP_EOL;
        }
        echo '}', PHP_EOL;
    }
}

$file = 'measurements.txt';
$threadsCount = isset($argv[1]) ? (int) $argv[1] : 1;

if ($threadsCount < 1) {
    echo "Number of threads must be at least 1.\n";
    exit(1);
}

$processor = new FileProcessor($file, $threadsCount);
$processor->process();
