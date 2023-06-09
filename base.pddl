;Header and description

(define (domain base)

    (:requirements :adl :fluents :time :typing)

    (:types
        waiter
        drink
        table bar - location
    )

    (:predicates

        ;waiter
        (moving ?w - waiter ?l - location)
        (using_tray ?w - waiter)
        (cleaning ?w - waiter ?t - table)
        (free ?w - waiter)

        ;common
        (at ?x ?y)

        ;drink
        (empty ?d - drink)
        (warm ?d - drink)
        (preparing ?d - drink)

        ;table
        (clean ?t - table)

    )

    (:functions

        ;barista
        (preparation_time)

        ;waiter
        (dist ?l1 - location ?l2 - location)
        (dist_to_goal ?w - waiter)
        (capacity ?w - waiter)
        (carrying ?w - waiter)

        ;table
        (size ?t - table)
        (time_to_clean ?t - table)

    )

    ;actions

    ;barista

    (:action make_cold_drink
        :parameters (?d - drink ?br - bar)
        :precondition (and (not (warm ?d)) (empty ?d) (at ?d ?br) (not (preparing ?d)) (= (preparation_time) 0))
        :effect (and (preparing ?d) (increase (preparation_time) 3))
    )

    (:action make_warm_drink
        :parameters (?d - drink ?br - bar)
        :precondition (and (warm ?d) (empty ?d) (at ?d ?br) (not (preparing ?d)) (= (preparation_time) 0))
        :effect (and (preparing ?d) (increase (preparation_time) 5))
    )

    ;waiter
    (:action move
        :parameters (?w - waiter ?from - location ?to - location)
        :precondition (and (at ?w ?from) (= (dist_to_goal ?w) 0) (free ?w))
        :effect (and (increase (dist_to_goal ?w) (dist ?from ?to)) (not (at ?w ?from)) (moving ?w ?to) (not (free ?w)))
    )

    (:action get_drink
        :parameters (?w - waiter ?d - drink ?br - bar)
        :precondition (and (not (empty ?d)) (at ?d ?br) (at ?w ?br) (< (carrying ?w) (capacity ?w)))
        :effect (and (at ?d ?w) (increase (carrying ?w) 1) (not (at ?d ?br)))
    )

    (:action serve
        :parameters (?w - waiter ?d - drink ?t - table)
        :precondition (and (at ?d ?w) (at ?w ?t))
        :effect (and (decrease (carrying ?w) 1) (not (at ?d ?w)) (at ?d ?t))
    )

    (:action start_cleaning
        :parameters (?w - waiter ?t - table)
        :precondition (and (at ?w ?t) (not (clean ?t)) (not (using_tray ?w)) (free ?w))
        :effect (and (cleaning ?w ?t) (assign (time_to_clean ?t) (* (size ?t) 2)) (not (free ?w)))
    )

    (:action equip_tray
        :parameters (?w - waiter ?br - bar)
        :precondition (and (not (using_tray ?w)) (at ?w ?br) (= (carrying ?w) 0))
        :effect (and (using_tray ?w) (increase (capacity ?w) 2))
    )

    (:action unequip_tray
        :parameters (?w - waiter ?br - bar)
        :precondition (and (using_tray ?w) (at ?w ?br) (= (carrying ?w) 0))
        :effect (and (not (using_tray ?w)) (decrease (capacity ?w) 2))
    )

    ;processes

    ;barista
    (:process preparing_drink
        :parameters (?d - drink)
        :precondition (and
            ; activation condition
            (preparing ?d)
            (> (preparation_time) 0)
        )
        :effect (and
            ; continuous effect(s)
            (decrease (preparation_time) (* #t 1))
        )
    )
    
    ;waiter
    (:process moving
        :parameters (?w - waiter)
        :precondition (and
            ; activation condition
            (> (dist_to_goal ?w) 0)
            (not (using_tray ?w))
        )
        :effect (and
            ; continuous effect(s)
            (decrease (dist_to_goal ?w) (* #t 2))
        )
    )

    (:process moving_with_tray
        :parameters (?w - waiter)
        :precondition (and
            ; activation condition
            (> (dist_to_goal ?w) 0)
            (using_tray ?w)
        )
        :effect (and
            ; continuous effect(s)
            (decrease (dist_to_goal ?w) (* #t 1))
        )
    )

    (:process cleaning
        :parameters (?w - waiter ?t - table)
        :precondition (and
            ; activation condition
            (cleaning ?w ?t)
            (> (time_to_clean ?t) 0)
        )
        :effect (and
            ; continuous effect(s)
            (decrease (time_to_clean ?t) (* #t 1))
        )
    )

    ;Events
    
    ;barista
    (:event finish_drink
        :parameters (?d - drink)
        :precondition (and
            ; trigger condition
            (preparing ?d)
            (= (preparation_time) 0)
        )
        :effect (and
            ; discrete effect(s)
            (not (preparing ?d))
            (not (empty ?d))
        )
    )
    
    ;waiter
    (:event arrived
        :parameters (?to - location ?w - waiter)
        :precondition (and
            ; trigger condition
            (moving ?w ?to)
            (<= (dist_to_goal ?w) 0)
        )
        :effect (and
            ; discrete effect(s)
            (not (moving ?w ?to))
            (at ?w ?to)
            (assign (dist_to_goal ?w) 0)
            (free ?w)
        )
    )

    (:event cleaned
        :parameters (?t - table ?w - waiter)
        :precondition (and
            ; trigger condition
            (<= (time_to_clean ?t) 0)
            (cleaning ?w ?t)
        )
        :effect (and
            ; discrete effect(s)
            (not (cleaning ?w ?t))
            (clean ?t)
            (free ?w)
        )
    )
    
)

