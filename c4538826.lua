--終焉龍 カオス・エンペラー
function c4538826.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4538826,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,4538826)
	e1:SetCost(c4538826.thcost)
	e1:SetTarget(c4538826.thtg)
	e1:SetOperation(c4538826.thop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCountLimit(1,4538827)
	e3:SetRange(LOCATION_EXTRA+LOCATION_HAND)
	e3:SetCondition(c4538826.spcon)
	e3:SetOperation(c4538826.spop)
	c:RegisterEffect(e3)
	--to grave and damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4538826,1))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c4538826.gycost)
	e4:SetTarget(c4538826.gytg)
	e4:SetOperation(c4538826.gyop)
	c:RegisterEffect(e4)
	--redirect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(c4538826.spreg)
	c:RegisterEffect(e5)
end
function c4538826.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c4538826.thfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function c4538826.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c4538826.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c4538826.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c4538826.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c4538826.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c4538826.spfilter(c,att)
	return c:IsAttribute(att) and c:IsAbleToRemoveAsCost()
end
function c4538826.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return ((c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or
		(c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)>0))
		and Duel.IsExistingMatchingCard(c4538826.spfilter,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_LIGHT)
		and Duel.IsExistingMatchingCard(c4538826.spfilter,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_DARK)
end
function c4538826.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c4538826.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,ATTRIBUTE_LIGHT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c4538826.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,ATTRIBUTE_DARK)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c4538826.gycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c4538826.gyfilter(c)
	return not c:IsLocation(LOCATION_MZONE) or c:GetSequence()<5
end
function c4538826.sgfilter(c,p)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(p)
end
function c4538826.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c4538826.gyfilter,tp,LOCATION_ONFIELD,0,nil)
	local og=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return g:GetCount()>0 and og:GetCount()>0 end
	local oc=og:GetCount()
	g:Merge(og)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,oc*300)
end
function c4538826.gyop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c4538826.gyfilter,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()==0 or Duel.SendtoGrave(g,REASON_EFFECT)==0 then return end
	local oc=Duel.GetOperatedGroup():FilterCount(c4538826.sgfilter,nil,tp)
	if oc==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local og=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,oc,nil)
	if Duel.SendtoGrave(og,REASON_EFFECT)>0 then
		local dc=Duel.GetOperatedGroup():FilterCount(c4538826.sgfilter,nil,1-tp)
		if dc==0 then return end
		Duel.BreakEffect()
		Duel.Damage(1-tp,dc*300,REASON_EFFECT)
	end
end
function c4538826.spreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e1:SetValue(LOCATION_DECKBOT)
	c:RegisterEffect(e1)
end
