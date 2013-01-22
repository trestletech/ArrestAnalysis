ages <- array()

assignAges <- function(ages, minAge, maxAge, pct){
  ages[minAge:maxAge] <- pct/(maxAge-minAge+1)
  ages
}

ages <- assignAges(ages, 1, 5, 5.6)
ages <- assignAges(ages, 5, 9, 5.5)
ages <- assignAges(ages, 10, 14, 6)
ages <- assignAges(ages, 15, 19, 6.5)
ages <- assignAges(ages, 20, 24, 5.2)
ages <- assignAges(ages, 25, 29, 5.2)
ages <- assignAges(ages, 30, 34, 5.0)
ages <- assignAges(ages, 35, 39, 5.0)
ages <- assignAges(ages, 40, 44, 5.9)
ages <- assignAges(ages, 45, 49, 7.3)
ages <- assignAges(ages, 50, 54, 8.6)
ages <- assignAges(ages, 55, 59, 8.5)
ages <- assignAges(ages, 60, 64, 8.0)
ages <- assignAges(ages, 65, 69, 5.9)
ages <- assignAges(ages, 70, 74, 4.3)
ages <- assignAges(ages, 75, 79, 3.1)
ages <- assignAges(ages, 80, 84, 2.3)
ages <- assignAges(ages, 85, 90, 2.1)