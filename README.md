# Golang Makefile

Makefile for golang projects. It checks go dependency automatically, and builds your go projects according to the changes. E.g., let's say you have two projects foo and bar, and the two projects share one common library mylog. After you modified the source files of mylog, and then type 'make', the two projects will get compiled. If you only modified the source files in project bar, only project bar will get compiled.

# Howto
1. Put the file 'Makefile' in your $GOPATH directory, if you have multi GOPATH direcotories, you can put it to all of them, or just the one where you lay your project.
2. Put the file 'library.mk' in the root directory of your project which produces library.
3. Put the file 'project.mk' in the root directory of your project which produces binary.
4. Type 'make' will build for debugging.
5. Type 'make release' will build for release.
6. Type 'make clean' will delete *~ and all products.

# FAQ
**Q: My project uses a third party library, shall I put the 'library.mk' in its project root directory?**

A: No. Your project will get compiled after you update the library. Put the 'library.mk' in your own library project.

# How it works
The Makefile uses the 'go list -f {{.Dep}} ...' to get the dependency for golang project. It recognizes the following source files: .go, .c, .cc, .cpp, .h, .cc, .hpp and .hxx. You can edit 'Makefile' to add your own. By the way, the Makefile **filters '*_test.go'**. Modify go test file will not cause the project got compiled. 

I also tried to use 
- go list -f {{.Dir}} ...
- go list -f {{.GoFiles/...}} ... 

to extract the dependency, but it is just too slow.
