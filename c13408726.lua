--メタトロンの影霊衣
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--Cannot Special Summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.rmcon)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	--remove 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+o)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e2:SetCondition(s.rmcon2)
	e2:SetTarget(s.rmtg2)
	e2:SetOperation(s.rmop2)
	c:RegisterEffect(e2)
	--bp remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e3:SetValue(LOCATION_REMOVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.immtg)
	c:RegisterEffect(e3)
end
function s.mat_filter(c)
	return not c:IsLevel(9)
end
function s.cfilter(c,tp)
	return c:IsFaceupEx() and c:IsPreviousControler(tp) and c:IsControler(tp) and c:IsSetCard(0xb4)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function s.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function s.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.rmfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToRemove()
end
function s.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return c:IsAbleToRemove() and chkc:IsOnField() and chkc:IsControler(1-tp) and s.rmfilter2(chkc) end
	if chk==0 then return c:IsAbleToRemove() and Duel.IsExistingTarget(s.rmfilter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.rmfilter2,tp,0,LOCATION_MZONE,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsAbleToRemove() and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		if c:GetOriginalCode()==id then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1,tp)
		end
		if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetHandler())
end
function s.immtg(e,c)
	return c:IsFaceup() and c:IsSetCard(0xb4)
end
