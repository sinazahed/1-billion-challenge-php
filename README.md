# 1BRC: One Billion Row Challenge in PHP


PHP implementation of Gunnar's 1 billion row challenge:

https://www.morling.dev/blog/one-billion-row-challenge

https://github.com/gunnarmorling/1brc

# usage

first of all you need to create a dataset, for this purpose run the bash script.
you can specify the number of records and threads.
you can also specify the name of the output file in bash script.

```
chmod +x datasetCreator.php
./datasetCreator.php

php avrageCalculator.php
```

# Requirements

This solutions requires a ZTS build of PHP and ext-parallel to be installed for that PHP version.



