#include "script_component.hpp"
/*
 * Author: nkenny
 * Checks if FSM level movement is forced
 *
 * Arguments:
 * 0: unit being tested <OBJECT>
 *
 * Return Value:
 * bool
 *
 * Example:
 * [bob] call lambs_danger_fnc_isForced;
 *
 * Public: No
*/
params ["_unit"];
fleeing _unit
|| {_unit getVariable [QGVAR(disableAI), false]}
|| {_unit getVariable [QGVAR(forceMove), false]}
|| {currentCommand _unit in ["ATTACK", "GET IN", "ACTION", "HEAL", "REARM", "JOIN"]}
|| {!(_unit call EFUNC(main,isAlive))}
|| {(_unit getVariable ["ace_medical_ai_healQueue", []]) isNotEqualTo []}
|| {GVAR(disableAIPlayerGroup) && {isPlayer leader _unit}}
|| {(behaviour _unit) isEqualTo "CARELESS"}
|| {!(_unit checkAIFeature "MOVE")}
