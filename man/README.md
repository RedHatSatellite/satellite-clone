# Man page #

We use pandoc to convert markdown into a man page format

```
yum install -y pandoc
pandoc --standalone --to man satellite-clone.md -o satellite-clone.1
```

General workflow (tested on fedora 26)
```
cd man/
pandoc --standalone --to man satellite-clone.md -o satellite-clone.1
sudo cp satellite-clone.1  /usr/local/share/man/man1/
sudo mandb
man 1 satellite-clone
```
