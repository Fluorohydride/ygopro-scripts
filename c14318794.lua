--生命吸収装置
---@param c Card
function c14318794.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14318794,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c14318794.reccon)
	e2:SetTarget(c14318794.rectg)
	e2:SetOperation(c14318794.recop)
	c:RegisterEffect(e2)
	if not c14318794.global_check then
		c14318794.global_check=true
		c14318794[0]=0
		c14318794[1]=0
		c14318794[2]=0
		c14318794[3]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PAY_LPCOST)
		ge1:SetOperation(c14318794.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TURN_END)
		ge2:SetOperation(c14318794.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c14318794.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==Duel.GetTurnPlayer() then
		local val=math.ceil(ev/2)
		c14318794[ep]=c14318794[ep]+val
	end
end
function c14318794.clear(e,tp,eg,ep,ev,re,r,rp)
	c14318794[ep+2]=c14318794[ep]
	c14318794[ep]=0
end
function c14318794.reccon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c14318794.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local val=c14318794[tp+2]
	if chk==0 then return val>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function c14318794.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
