extends Reference

class_name Random

"""
Object constructor, requires a seed value to feed the PRNG.
You can use a const seed or an already randomized one. See randi()
"""
func _init(_seed: int) -> void:
	set_seed(_seed)

"""
Changes current seed of the PRNG.
Needs to be pre-processed to allow 32-bits seeds without bias.
"""
func set_seed(value: int) -> void:
	_seed = value * PCG_SCALE + PCG_INC
	reset()

"""
Resets current random sequence to its initial state.
This guarantees the same random sequence will be fetched.
"""
func reset() -> void:
	_current = _seed

"""
Returns a random integer in the -MAX_RAND_INT...+MAX_RAND_INT range.
"""
func signed_int() -> int:
	var result = rand_seed(_current)
	_current = result[1]
	return result[0]

"""
Returns a random integer in the 0...(2 * MAX_RAND_INT) range.
"""
func unsigned_int() -> int:
	return signed_int() + MAX_RAND_INT

"""
Returns a random integer in the given range, both endpoints included.
"""
func int_in_range(from: int, to: int) -> int:
	return from + unsigned_int() % (to - from + 1)

"""
Returns a random float in the -1.0...+1.0 range.
"""
func signed_float() -> float:
	return signed_int() / float(MAX_RAND_INT)

"""
Returns a random float in the 0.0...1.0 range.
"""
func unsigned_float() -> float:
	return 0.5 + 0.5 * signed_float()

"""
Returns a random float in the given range, both endpoints included.
"""
func float_in_range(from: float, to: float) -> float:
	return from + unsigned_float() * (to - from + 1)

"""
Returns one of the elements of a given array at random.
"""
func one_of_array(bag: Array):
	return bag[int_in_range(0, bag.size())]

"""
Returns one of the elements of a given dictionary at random.
"""
func one_of_dict(bag: Dictionary):
	return bag[one_of_array(bag.keys())]

"""
Private variables
"""

# Current seed
var _current : int

# Initial seed
var _seed : int

# Max value of a rand_seed result
const MAX_RAND_INT = 0x7FFFFFFF

# Scale and increment to get 64-bit generation from 32-bit seeds
const PCG_SCALE = 12047754176567800795
const PCG_INC = 1442695040888963407
