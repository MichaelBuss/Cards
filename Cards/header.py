#!/usr/bin/env python3
from ev3dev.auto import *

# Connect sensors.
ts = TouchSensor();    assert ts.connected
cs = ColorSensor();    assert ts.connected
cs.mode = 'COL-COLOR'
us = UltrasonicSensor();    assert ts.connected
us.mode = 'US-DIST-CM' # reports 'cm' even though the sensor measures 'mm'
btn = Button()
mB = LargeMotor('outB')
mC = LargeMotor('outC')
mA = MediumMotor('outA')

# Variables
rotationmm = {rotationmm} # One wheel rotation equals x mm. From configure panel in app. Can be static for now
rotationdeg = {rotationdeg} # One wheel rotation in opposite directions equals the robot turning x degrees. From configure panel in app. Can be static for now
driveRatio = (360/(rotationmm))*10
turnRatio = 360/rotationdeg

Sound.speak('Starting').wait()

def drive(unit="degrees", amount=360, speed=50, direction=1):
	# unit = degrees, seconds, rotations, cm
	# amount = any int
	# speed = 0-100
	# direction = +/-1
	speed = speed*direction*10 # Because ev3dev motors gros from -1000 to +1000

	if unit == "degrees":
		# run_to_rel_pos is the only one that don't react to negative speed, thus *direction on position instead
		mB.run_to_rel_pos(position_sp=amount*direction, speed_sp=speed, stop_action="brake")
		mC.run_to_rel_pos(position_sp=amount*direction, speed_sp=speed, stop_action="brake")
		mB.wait_while('running')
		mC.wait_while('running')
	elif unit == "seconds":
		amount = amount*1000 # Because ev3dev uses milliseconds
		mB.run_timed(time_sp=amount, speed_sp=speed, stop_action="brake")
		mC.run_timed(time_sp=amount, speed_sp=speed, stop_action="brake")
		mB.wait_while('running')
		mC.wait_while('running')
	elif unit == "rotations":
		mB.run_to_rel_pos(position_sp=amount*direction*360, speed_sp=speed, stop_action="brake")
		mC.run_to_rel_pos(position_sp=amount*direction*360, speed_sp=speed, stop_action="brake")
		mB.wait_while('running')
		mC.wait_while('running')
	elif unit == "cm":
		# run_to_rel_pos is the only one that don't react to negative speed, thus *direction on position instead
		mB.run_to_rel_pos(position_sp=amount*direction*driveRatio, speed_sp=speed, stop_action="brake")
		mC.run_to_rel_pos(position_sp=amount*direction*driveRatio, speed_sp=speed, stop_action="brake")
		mB.wait_while('running')
		mC.wait_while('running')
	elif unit == "untilTouch":
		while not ts.value():
			drive(unit="forever")
			brake()
	else:
		mB.run_forever(speed_sp=speed, stop_action="brake")
		mC.run_forever(speed_sp=speed, stop_action="brake")


def brake():
	mB.stop(stop_action="brake")
	mC.stop(stop_action="brake")


def turn(unit ="degrees", amount=90, speed=50, direction=1):
	if unit == "degrees":
		speed = speed*10 # Because ev3dev motors goes from -1000 to +1000
		# run_to_rel_pos is the only one that don't react to negative speed, thus *direction on position instead
		mB.run_to_rel_pos(position_sp=amount*turnRatio*direction, speed_sp=speed, stop_action="brake")
		mC.run_to_rel_pos(position_sp=amount*turnRatio*-direction, speed_sp=speed, stop_action="brake")
		mB.wait_while('running')
		mC.wait_while('running')

def singleMotor(unit="rotations", amount=1, speed=50, direction=1):
    if unit == "rotations":
        speed = speed*10
        mA.run_to_rel_pos(position_sp=amount*turnRatio*direction*360, speed_sp=speed, stop_action="brake")
        mA.wait_while('running')
