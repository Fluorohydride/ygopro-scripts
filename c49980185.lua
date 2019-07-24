--超能力治療
function c49980185.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCondition(c49980185.reccon)
	e1:SetTarget(c49980185.rectg)
	e1:SetOperation(c49980185.recop)
	c:RegisterEffect(e1)
	if not c49980185.global_check then
		c49980185.global_check=true
		c49980185[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c49980185.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c49980185.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c49980185.checkop(e,tp,eg,ep,ev,re,r,rp)
	c49980185[0]=c49980185[0]+eg:FilterCount(Card.IsRace,nil,RACE_PSYCHO)
end
function c49980185.clear(e,tp,eg,ep,ev,re,r,rp)
	c49980185[0]=0
end
function c49980185.reccon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetCurrentPhase()==PHASE_END
end
function c49980185.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c49980185[0]~=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(c49980185[0]*1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,c49980185[0]*1000)
end
function c49980185.recop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,c49980185[0]*1000,REASON_EFFECT)
end
