# Computational geometry
Implementation and visualization of 2D computational geometry algorithms along with the necessary data structures.

## Dependencies
- [OCaml](https://ocaml.org/)
- [Dune](https://dune.build/)
- [Graphics](https://ocaml.github.io/graphics/graphics/Graphics/index.html)

## References
- Mark de Berg, Otfried Cheong, Marc van Kreveld, Mark Overmars. *Computational Geometry: Algorithms and Applications*. 3rd Edition, Springer, 2008.

## Algorithms

> [!NOTE]
> In `lib/algorithms`, each algorithm includes a brief, non-rigorous explanation designed to convey the main idea behind how it works. These summaries aim to be intuitive and accessible without diving into formal proofs or details.

### Convex hull
![](screenshots/convex_hull.png)

Run the following command:

``` bash
dune exec scenes/convex_hull.exe
```
Once the program is running, click on the screen to add points and the hull will be computed dynamically.

### Segments intersections (fast)
![](screenshots/segments_intersections.png)

Run the following command:

``` bash
dune exec scenes/segments_intersections.exe
```
1. Click anywhere on the screen to set the first endpoint of a segment.
2. While holding the mouse button, drag to your desired position.
3. Release the mouse button to set the second endpoint of the segment.
