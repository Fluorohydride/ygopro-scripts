--Mitsurugi Tempest
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,13332685,19899073,55397172)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.spchecks=aux.CreateChecks(Card.IsOriginalCodeRule,{13332685,19899073,55397172})
function s.cfilter(c)
	return c:IsSetCard(0x1c3) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function s.rlfilter(c,tp)
	return c:IsOriginalCodeRule(13332685,19899073,55397172) and (c:IsControler(tp) or c:IsFaceup())
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetReleaseGroup(tp,false):Filter(s.rlfilter,c,tp)
	if chk==0 then return g:CheckSubGroupEach(s.spchecks) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroupEach(tp,s.spchecks,false)
	aux.UseExtraReleaseCount(rg,tp)
	Duel.Release(rg,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA)
	if chk==0 then return Duel.IsPlayerCanRemove(1-tp)
		and g:IsExists(Card.IsAbleToRemove,8,nil,1-tp,POS_FACEUP,REASON_RULE) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanRemove(1-tp) then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA,nil,1-tp,POS_FACEUP,REASON_RULE)
	if g:GetCount()>7 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,8,8,nil)
		if sg:GetCount()>7 then
			Duel.Remove(sg,POS_FACEUP,REASON_RULE,1-tp)
		end
	end
end
