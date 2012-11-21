for f in *.escad; do ~/ImplicitCAD-treeoperators/extopenscad $f tutorial-`echo $f | sed s/.escad/-tut.png/`; done


