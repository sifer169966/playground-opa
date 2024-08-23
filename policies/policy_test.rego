package main

test_allowed {
    allowed with input as {"n": 1000}
}

test_not_allowed {
    not allowed with input as {"n": 10}
}