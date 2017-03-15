ImplicitCAD FAQ
================

General
-------

**What is ImplicitCAD?** ImplicitCAD is an open-source programmatic CAD tool. A programming language that compiles into 3D objects. It is intended as a serious CAD program.

**Why Programmatic CAD?** Programmatic CAD has a lot of advantages:

* Objects can abstracted and reused
* Repetitive tasks can be automated
* Objects can be designed parametrically
* The usual tools for software development (like version control) can be used

**What's the difference between ImplicitCAD and extopenscad?** ImplicitCAD is the full project. Extopenscad is part of ImplicitCAD, responsible for the interpretation of our (mostly) OpenSCAD backwards-compatible programming language.

**Do I have to design objects in the Extopenscad language?** Nope. ImplicitCAD provides a Haskell API, so you can also design objects in Haskell. Haskell functions can quite easily be exported to C, so using ImplicitCAD to design objects in C is also possible. From there, most languages support interacting with C, so with a bit of work you should be able to use ImplicitCAD to design objects in your language of preference...

**How do I try ImplicitCAD/Extopenscad?** You can try ImplicitCAD without installing it at [implicitcad.org](http://implicitcad.org) or by installing it locally on your computer by following the [installation instructions](http://github.com/colah/ImplicitCAD/).

ImplicitCAD and OpenSCAD
-------------------------

**Is ImplicitCAD a fork of OpenSCAD?** Nope. ImplicitCAD is an entirely separate project, sharing no code with OpenSCAD. It definitely draws some inspiration from OpenSCAD, though. :)

**Is it based on OpenCSG and CGAL like OpenSCAD?** Nope. ImplicitCAD has a custom graphics engine instead of relying on external libraries.

**How do ImplicitCAD's graphics capabilities differe from OpenSCAD?**

* ImplicitCAD is capable of describing a much wider range of primitives and transformations. An example of this would be rounded unions, which are like unions except with the interface between the objects rounded.

* ImplicitCAD has a perfect internal model of your object. It is of infinite resolution. In order to access it, it is rendered into an approximating triangle mesh, a raytraced image or GCode. These approximations can be of varying quality, depending on what you request.

**Is ImplicitCAD Faster than OpenSCAD?** It depends. In the cases you care about, probably.

* The speed of ImplicitCAD depends on quality of the rendering you are trying to make. To make models of comparable quality to their OpenSCAD counter parts, ImplicitCAD is generally much faster.

* OpenSCAD's performance drastically slows down as objects get more complex. ImplicitCAD's performance is much less affected by the complexity of the objects it is rendering (more affected by the quality of object you ask it to render). ImplicitCAD also often has simpler ways of representing objects than OpenSCAD.

* ImplicitCAD is capable of parallel rendering. Unlike OpenSCAD, it is happy to use more threads and be faster!

**Does ImplicitCAD have a GUI like OpenSCAD?** Nope. ImplicitCAD is just the compiler. It seems healthy to separate IDEs and underlying language. That said, if you want IDE integration, *implicitsnap.hs* compiles into a REST API server. And there's an online IDE at [implicitcad.org](http://implicitcad.org).

**How does the extopenscad language vary from OpenSCAD?**

* Proper variables / computation. For example, the following code doesn't really work in OpenSCAD:

```
a = 5;
for (c = [1, 2, 3]) {
    echo(c);
    a = a*c;
    echo(a);
}
```

* ImplicitCAD does not have implicit unions. So,

```
sphere(10);
translate([20,0,0]) sphere(5);
```

will only show the first sphere. You need to use a union, like

```
union(){
  sphere(10);
  translate([20,0,0]) sphere(5);
}
```

* ImplicitCAD often has much more general operations than those in OpenSCAD, for example:

  * `union(r=...)` -- rounded unions
  * `linear_extrude(height(x,y) = ...)` -- variable height extrusions
  * `linear_extrude(twist(h) = ...)` -- variable twist extrusions
  * And much more! 


Technical and Contribution
--------------------------

**What is ImplicitCAD written in?** ImplicitCAD is pure Haskell. Don't run away! I know some people are intimidated by Haskell, but it is a really lovely language. And ImplicitCAD has been written with approachability and ease of hacking in mind. The code is well documented.

**How big is ImplicitCAD?** For an entire programming language interpreter and graphics engine, remarkably small. ImplicitCAD is around four thousand lines of code, and two thousand lines of comments and blanks.

**How does ImplicitCAD work?** Everything is internally an implicit function. This means that changes are just mathematical transformations. Learn more by reading this [essay](http://christopherolah.wordpress.com/2011/11/06/manipulation-of-implicit-functions-with-an-eye-on-cad/).

**How do I contribute?** We'd love for you to contribute! Please begin by looking at *hacking.md* which will walk you through the project and common modifications you might want to make.

