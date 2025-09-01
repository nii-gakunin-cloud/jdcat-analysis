# Manual for JDCat analysis
Preparations for moving documents due to the discontinuation of meatwiki

### Prepare files for local test into testlocal/
```
$ ./absolute_url.sh
$ cd testlocal
```

### Restore files for WWW into work/
```
$ ./relative_url.sh
```

### Workflow

1. Clone this repository.
2. Run ./absolute_url.sh
3. Edit and view test
4. Run ./relative_url.sh
5. Stage changes
6. Git commit
7. git push