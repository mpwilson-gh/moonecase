
// begin screw_holes.scad

// Gonna use this as a place to try and keep dimensional calculations
// (or, let's be honest, look up tables) for screw hole dimension calculations.

// I've been botching them up on the moonecase project for a week, so it's time.

// Ironical, since I just sent what I thought was the "last" release candidate 
// to the printer.  Alas.  

// ANYwho.

// I'm starting from a bog standard metric tapping chart I found on the 
// innert00bz.




// Coarse.
function get_screw_hole_diameter_mm(thread_size) =
    thread_size == 1   ? 0.75 :
    thread_size == 1.1 ? 0.85 :
    thread_size == 1.2 ? 0.95 :
    thread_size == 1.4 ? 1.1  :
    thread_size == 1.6 ? 1.25 :
    thread_size == 1.8 ? 1.45 :
    thread_size == 2   ? 1.6  :
    thread_size == 2.2 ? 1.75 :
    thread_size == 2.5 ? 2.05 :
    thread_size == 3   ? 2.5  :

    thread_size == 3.5 ? 2.9 :
    thread_size == 4   ? 3.3 :
    thread_size == 4.5 ? 3.7 :
    thread_size == 5   ? 4.2 :
    thread_size == 6   ? 5.0 :
    thread_size == 7   ? 6.0 :
    thread_size == 8   ? 6.8 :
    thread_size == 9   ? 7.8 :
    thread_size == 10  ? 8.5 :
    thread_size == 11  ? 9.5 :

    thread_size == 12  ? 10.20 :
    thread_size == 14  ? 12.00 :
    thread_size == 16  ? 14.00 :
    thread_size == 18  ? 15.50 :
    thread_size == 20  ? 17.50 :
    thread_size == 22  ? 19.50 :
    thread_size == 24  ? 21.00 :
    thread_size == 27  ? 24.00 :
    thread_size == 30  ? 26.50 :
    thread_size == 33  ? 29.50 :

    thread_size == 36  ? 32.00 :
    thread_size == 39  ? 35.00 :
    thread_size == 42  ? 37.50 :
    thread_size == 45  ? 40.50 :
    thread_size == 48  ? 43.00 :
    thread_size == 52  ? 47.00 :
    thread_size == 56  ? 50.50 :
    thread_size == 60  ? 54.50 :
    thread_size == 64  ? 58.00 :
    thread_size == 68  ? 62.00 :
    thread_size == undef;


// Fine.

// Left as an exercise for the reader :p
// I'm not bothering with the thread pitch calculations.  
// You wanna do that, knock yourself out.  
// Here: http://www.shender4.com/metric_thread_chart.htm

// end screw_holes.scad
