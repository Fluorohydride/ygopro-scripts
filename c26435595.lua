--聖菓使クーベル
function c26435595.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_PENDULUM),2,true)
	aux.EnablePendulumAttribute(c,false)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26435595,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,26435595)
	e1:SetTarget(c26435595.pctg)
	e1:SetOperation(c26435595.pcop)
	c:RegisterEffect(e1)
	--pendulum
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26435595,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c26435595.pencon)
	e2:SetTarget(c26435595.pentg)
	e2:SetOperation(c26435595.penop)
	c:RegisterEffect(e2)
end
function c26435595.pcfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function c26435595.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c26435595.pcfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
end
function c26435595.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c26435595.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c26435595.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c26435595.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c26435595.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
