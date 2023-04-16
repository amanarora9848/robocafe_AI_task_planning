(define (problem problem1) (:domain base)
(:objects
    w1 w2 - waiter
    drink1 drink2 drink3 drink4 - drink
    br - bar
    table1 table2 table3 table4 - table
    o1 o2 - order
)

(:init
    (at w1 br) (free w1) (at w2 table2) (free w2)
    (occupied br) (is_bar br)
    (at drink1 br) (at drink2 br) (at drink3 br) (at drink4 br)
    (empty drink1) (empty drink2) (empty drink3) (empty drink4)
    (warm drink1) (warm drink2) (warm drink3) (warm drink4)
    (= (dist br table1) 2) (= (dist br table2) 2) (= (dist br table3) 3) (= (dist br table4) 3)
    (= (dist table1 br) 2) (= (dist table2 br) 2) (= (dist table3 br) 3) (= (dist table4 br) 3)
    (= (dist table1 table2) 1) (= (dist table1 table3) 1) (= (dist table1 table4) 1)
    (= (dist table2 table3) 1) (= (dist table2 table4) 1) (= (dist table2 table1) 1)
    (= (dist table3 table4) 1) (= (dist table3 table1) 1) (= (dist table3 table2) 1)
    (= (dist table4 table1) 1) (= (dist table4 table2) 1) (= (dist table4 table3) 1)
    (= (capacity w1) 1) (= (capacity w2) 1)
    (= (carrying w1) 0) (= (carrying w2) 0)
    (= (dist_to_goal w1) 0) (= (dist_to_goal w2) 0)
    (= (preparation_time) 0)
    (= (size table1) 1) (= (size table2) 1) (= (size table3) 2) (= (size table4) 1)
    (= (time_to_clean table1) 0) (= (time_to_clean table2) 0) (= (time_to_clean table3) 0) (= (time_to_clean table4) 0)
    (clean table1) (clean table2) (clean table4)
    (destination o1 table4) (destination o2 table1)
    (elem o1 drink1) (elem o1 drink2) (elem o2 drink3) (elem o2 drink4)
    (= (biscuit_count o1) 0) (= (biscuit_count o2) 0)
)

(:goal (and
    (served o1) (served o2)
    (consumed o1) (consumed o2)
    (clean table1) (clean table2) (clean table3) (clean table4)
    (not (using_tray w1)) (not (using_tray w2))
    (not (cooled drink1)) (not (cooled drink2)) (not (cooled drink3)) (not (cooled drink4))
))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)