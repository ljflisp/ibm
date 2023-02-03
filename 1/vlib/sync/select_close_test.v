import sync
import time

fn do_rec_i64(mut ch sync.Channel) {
	mut sum := i64(0)
	for i in 0 .. 300 {
		if i == 200 {
			ch.close()
		}
		mut a := i64(0)
		if ch.pop(&a) {
			sum += a
		}
	}
	assert sum == 200 * (200 - 1) / 2
}

fn do_send_int(mut ch sync.Channel) {
	for i in 0 .. 300 {
		ch.push(&i)
	}
	ch.close()
}

fn do_send_byte(mut ch sync.Channel) {
	for i in 0 .. 300 {
		ii := byte(i)
		ch.push(&ii)
	}
	ch.close()
}

fn do_send_i64(mut ch sync.Channel) {
	for i in 0 .. 300 {
		ii := i64(i)
		ch.push(&ii)
	}
	ch.close()
}

fn test_select() {
	mut chi := sync.new_channel<int>(0)
	mut chl := sync.new_channel<i64>(1)
	mut chb := sync.new_channel<byte>(10)
	mut recch := sync.new_channel<i64>(0)
	go do_rec_i64(mut recch)
	go do_send_int(mut chi)
	go do_send_byte(mut chb)
	go do_send_i64(mut chl)
	mut channels := [chi, recch, chl, chb]
	directions := [sync.Direction.pop, .push, .pop, .pop]
	mut sum := i64(0)
	mut rl := i64(0)
	mut ri := int(0)
	mut rb := byte(0)
	mut sl := i64(0)
	mut objs := [voidptr(&ri), &sl, &rl, &rb]
	for j in 0 .. 1101 {
		idx := sync.channel_select(mut channels, directions, mut objs, time.infinite)
		match idx {
			0 {
				sum += ri
			}
			1 {
				sl++
			}
			2 {
				sum += rl
			}
			3 {
				sum += rb
			}
			-2 {
				// channel was closed - last item
				assert j == 1100
			}
			else {
				println('got $idx (timeout)')
				assert false
			}
		}
		if j == 1100 {
			// check also in other direction
			assert idx == -2
		}
	}
	// Use Gauß' formula for the first 2 contributions
	// the 3rd contribution is `byte` and must be seen modulo 256
	expected_sum :=  2 * (300 * (300 - 1) / 2) +
		256 * (256 - 1) / 2 +
		44 * (44 - 1) / 2
	assert sum == expected_sum
}