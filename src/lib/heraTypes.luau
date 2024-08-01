local heraTypes = {};

export type heraInterpolationValidationType = number | Vector3 | CFrame | Color3 | Instance;

export type heraHandleType = "HERA_HANDLE_TYPE_LINEAR" | "HERA_HANDLE_TYPE_CUBIC" | "HERA_HANDLE_TYPE_BEZIER";

export type heraCurveCreateInfo = {
	name : string;
};

export type heraCurveBinCreateInfo = {
	name : string;
};

export type heraCurveHandleCreateInfo = {
	name : string;
};

export type heraEnvironmentCreateInfo = {
	name : string;
};

export type heraFileCreateInfo = {
	name : string;
};

export type heraKeyframeCreateInfo = {
	name : string;
	value : any;
	handleType : heraHandleType;
	time : number;
};

export type heraPortCreateInfo = {
	name : string;
};

export type heraSequenceCreateInfo = {
	name : string;
	object : Instance;
};

export type heraTimelineCreateInfo = {
	name : string;
};

export type heraTransitCreateInfo = {
	name : string;
};

export type heraGuiCreateInfo = {
	name : string;
};

export type heraComputedKeyframeStateCreateInfo = {
	keyframeA : any;
	keyframeB : any;
	object : Instance;
	property : string;
};

return heraTypes;