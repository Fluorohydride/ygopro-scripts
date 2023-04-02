--削りゆく命
function c38105306.initial_effect(c)
	c:SetUniqueOnField(1,0,38105306)
	c:EnableCounterPermit(0x62)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c38105306.ctcon)
	e2:SetTarget(c38105306.cttg)
	e2:SetOperation(c38105306.ctop)
	c:RegisterEffect(e2)
	--discard
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_END)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(c38105306.hdcon)
	e3:SetTarget(c38105306.hdtg)
	e3:SetOperation(c38105306.hdop)
	c:RegisterEffect(e3)
end
function c38105306.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c38105306.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x62)
end
function c38105306.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x62,1)
	end
end
function c38105306.hdcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_MAIN1 and ph<=PHASE_MAIN2 and e:GetHandler():GetCounter(0x62)>0
end
function c38105306.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGrave() end
	e:SetLabel(c:GetCounter(0x62))
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c38105306.hdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT) then
		Duel.BreakEffect()
		Duel.DiscardHand(1-tp,nil,e:GetLabel(),e:GetLabel(),REASON_EFFECT+REASON_DISCARD)
	end
end
