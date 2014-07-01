%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem 1: Rules

% Return True if the item X is at the taqueria Y
available_at(X,Y) :- taqueria(Y, _, L), isin(X,L).

% return true if the item X is available in more than one place
multi_available(X) :- bagof(X, ma_goal(X), Dishes), % collection sat' ma_goal
                      remove_duplicates(Dishes, Result), % removes doubles
                      isin(X, Result). % check if queried dish is in found dishes  
% helper function for multi_available that checks if a dish is available at
% two different taquerias 
ma_goal(Dish) :- available_at(Dish, Taqueria1),
                 available_at(Dish, Taqueria2),
                 Taqueria1 \= Taqueria2.

% True if the person X works at more than one taqueria
overworked(X) :- bagof(X, ow_goal(X), Employees),
                 remove_duplicates(Employees, Result),
                 isin(X, Result). %check if queried worker is in found workers
% helper function for overworked() that checks if an employee is available at
% two different taquerias
ow_goal(Employee) :- taqueria(T1, Emp1, _), taqueria(T2, Emp2, _),
                     isin(Employee, Emp1), isin(Employee, Emp2), T1 \= T2.

% True if the sum of the cost of the ingredients of item X is equal to K.
total_cost(X,K) :- ingredients(X, List), cost_of_ingredients(List, K).
% helper function which recursively finds the cost of the head item of the list
% of ingredients then adds it to the tail list of ingredients
cost_of_ingredients([], 0). % base case, empty list of ingredients is $0
cost_of_ingredients([H|T], Cost) :- cost(H, CostHead),
                                    cost_of_ingredients(T, CostTail),
                                    Cost is CostTail + CostHead.

% True if the item X has all of the ingredients listed in L
has_ingredients(X,L) :- ingredients(X, IngList),
                        intersection(L, IngList, L).
 % Note: intersection returns list of elements in same order as first list L,
 %  so if L is equal to ouput list (last list) then know all of L intersects
 %  with, and are included in, the ingredients of item X 

% True if the item X does not have any of the ingredients listed in L
avoids_ingredients(X,L) :- ingredients(X, IngList), % get list of ingredients
                           intersection(L, IngList, Result),
                           length(Result, Len), Len == 0.
% Note: if length of the intersection of the query list and the ingredient list
% is zero, then the two do not share any items and avoids_ingredients -> true. 

% find_items(L, X, Y) returns true if L is the list of all items that contain
% all the ingredients in X and do not contain any of the ingredients in Y. 
% helper functions use bagof to get list of all values specified by X or Y
% p1 returns true if the list of items L has the ingredients specified by X 
p1(L,X) :- bagof(Item, has_ingredients(Item, X), L).
% p2 returns true if the list of items L does not have any ingredients from the
% list Y
p2(L,Y) :- bagof(Item, avoids_ingredients(Item, Y), L).
% find_items first generates a list L1 with items that have the ingredients in 
% X, then generates a list L2 of items that do not have the ingredients 
% specified in Y, then it takes the intersection of those two lists.
find_items(L,X,Y) :- p1(L1,X),p2(L2,Y),intersection(L1,L2,L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



