#include "script_component.hpp"
/*
 * Author: nkenny
 * Determines range which information is shared
 *
 * Arguments:
 * 0: unit sharing information <OBJECT>
 * 1: default range <NUMBER>
 * 2: override range <BOOLEAN>
 * 3: unit has has a long range radio <BOOLEAN>
 *
 * Return Value:
 * Array containing, unit doing the call, radio range, and presence of backpack radio
 *
 * Example:
 * [bob] call lambs_main_fnc_getShareInformationParams;
 *
 * Public: No
*/
params ["_unit", ["_range", 1000], ["_override", false], ["_radio", false]];

// override
if (_override) exitWith { [_unit, _range, _radio] };

// get range by faction
_range = switch (side _unit) do {
    case WEST: { GVAR(radioWest) };
    case EAST: { GVAR(radioEast) };
    default { GVAR(radioGuer) };
};

// tweak by VD ~ uncommented, not sure why it was there in the first place - nkenny
//_range = _range min viewDistance;

// Sort long range radios
private _target = _unit;

private _units = units _unit select {
    _x call FUNC(isAlive)
    && {_x distance2D _unit < 150}
    && {!isPlayer _x}
};
private _index = _units findIf {
        _x getVariable [QEGVAR(danger,dangerRadio), false]
        || {(!isNull objectParent _x && {_x distance2D _unit < 70})}
        || {(toLower backpack _x) find "b_radiobag_01_" isEqualTo 0}
        || {(getNumber (configFile >> "CfgVehicles" >> (backpack _x) >> "tf_hasLRradio")) isEqualTo 1}
};
_radio = _index != -1;
if (_radio) then {
    _target = _units select _index;
    _range = _range + GVAR(radioBackpack);
};
// tweak by height above sea-level
_range = _range + (linearConversion [-200, 600, (getPosASL _unit) select 2, -400, 1200, true]);

// return unit and range
[_target, _range, _radio]
