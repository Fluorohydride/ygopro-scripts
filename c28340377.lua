--絵札の絆
function c28340377.initial_effect(c)
	aux.AddCodeList(c,25652259,64788463,90876561)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28340377,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,28340377)
	e2:SetCondition(c28340377.spcon)
	e2:SetTarget(c28340377.sptg)
	e2:SetOperation(c28340377.spop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(28340377,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,28340377)
	e3:SetCost(c28340377.drcost)
	e3:SetTarget(c28340377.drtg)
	e3:SetOperation(c28340377.drop)
	c:RegisterEffect(e3)
end
function c28340377.confilter(c)
	return c:IsFaceup() and c:IsCode(64788463,25652259,90876561)
end
function c28340377.spcon(e,tp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return #g==0 or (#g>0 and g:FilterCount(c28340377.confilter,nil)==#g)
end
function c28340377.spfilter(c,e,tp)
	return c:IsCode(64788463,25652259,90876561) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c28340377.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c28340377.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c28340377.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28340377.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c28340377.cfilter(c)
	return c:IsCode(64788463,25652259,90876561) and c:IsAbleToRemoveAsCost()
end
function c28340377.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c28340377.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local mt=g:GetClassCount(Card.GetCode)
	if chk==0 then return mt>0 end
	local ct=1
	for i=2,3 do
		if Duel.IsPlayerCanDraw(tp,i) then ct=i end
	end
	if mt<ct then ct=mt end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	e:SetLabel(Duel.Remove(sg,POS_FACEUP,REASON_COST))
end
function c28340377.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c28340377.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
