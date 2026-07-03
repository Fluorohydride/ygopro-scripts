--トイ・ボックス
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(s.sttg)
	e2:SetOperation(s.stop)
	c:RegisterEffect(e2)
	--destroy facedown
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	--destroy monster
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.dmcon)
	e4:SetCost(s.dmcost)
	e4:SetTarget(s.dmtg)
	e4:SetOperation(s.dmop)
	c:RegisterEffect(e4)
end
function s.stfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1a8) and c:IsSSetable()
		and c.set_as_spell and c:IsFaceupEx()
end
function s.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.stfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
end
function s.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local ct=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),2)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.stfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE,0,1,ct,nil)
	Duel.SSet(tp,g)
end
function s.desfilter(c)
	return c:GetSequence()<5
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_SZONE,0,nil)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_SZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,2,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function s.dmcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function s.cfilter(c,tp)
	return c:IsFacedown() and c:IsAbleToGraveAsCost()
end
function s.dmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_ONFIELD,0,1,1,c,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ac=Duel.GetAttacker()
	if chk==0 then return ac:IsOnField() end
	Duel.SetTargetCard(ac)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ac,1,0,0)
end
function s.dmop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetFirstTarget()
	if ac:IsRelateToEffect(e) and ac:IsControler(1-tp) and ac:IsType(TYPE_MONSTER) then
		Duel.Destroy(ac,REASON_EFFECT)
	end
end
