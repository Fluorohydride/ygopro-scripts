--異次元ジェット・アイアン号
function c15574615.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c15574615.spcon)
	e1:SetOperation(c15574615.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15574615,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c15574615.cost)
	e2:SetTarget(c15574615.target)
	e2:SetOperation(c15574615.operation)
	c:RegisterEffect(e2)
end
function c15574615.sprfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
		and c:IsCode(80208158,16796157,43791861,79185500)
end
function c15574615.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local mg=Duel.GetMatchingGroup(c15574615.sprfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	return mg:GetClassCount(Card.GetCode)==4
		and mg:Filter(Card.IsLocation,nil,LOCATION_MZONE):GetClassCount(Card.GetCode)>=ct
end
function c15574615.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local mg=Duel.GetMatchingGroup(c15574615.sprfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local g=Group.CreateGroup()
	for i=1,4 do
		local tc=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		if ct>0 then
			tc=mg:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE):GetFirst()
			ct=ct-1
		else
			tc=mg:Select(tp,1,1,nil):GetFirst()
		end
		mg:Remove(Card.IsCode,nil,tc:GetCode())
		g:AddCard(tc)
	end
	Duel.SendtoGrave(g,REASON_COST)
end
function c15574615.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c15574615.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c15574615.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3
		and Duel.IsExistingTarget(c15574615.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,80208158)
		and Duel.IsExistingTarget(c15574615.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,16796157)
		and Duel.IsExistingTarget(c15574615.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,43791861)
		and Duel.IsExistingTarget(c15574615.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,79185500) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c15574615.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,80208158)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c15574615.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,16796157)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=Duel.SelectTarget(tp,c15574615.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,43791861)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g4=Duel.SelectTarget(tp,c15574615.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,79185500)
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,4,0,0)
end
function c15574615.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if g:GetCount()>ft then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
