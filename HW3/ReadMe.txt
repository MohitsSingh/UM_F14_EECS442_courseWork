In this folder you will find the following:

1) Two folders - Q2 and Q3 
2) One function for you to use for the problem 2. A description of the functions is available below. 
3) A pdf with the questions


Folder Q2 contains images for Question 2
Folder Q3 contains images for Question 3

-------------------------------------------------------------------------------
Usage description of the two attached MatLab functions.

function v = getVanishingPoint(im)
% An interactive function that facilitates computing a 
% vanishing point given an image 'im' as input.
% Usage: Select two points from the first line and then two more for the
% second line.
% Output v is a vanishing point such that: (v(1),v(2)) = (x,y)
Vanishing point is calculated in this way:
Let P1, P2 belong to line P and Q1, Q2 belong to line Q. Let P||Q.
Using the respective points in the two lines P and Q, we compute their line equations in 2D.
We then extrapolate the lines till they meet to find the Vanishing Points.


