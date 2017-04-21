--トレジャー・パンダー
function c45221020.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(45221020,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c45221020.sptg)
	e1:SetOperation(c45221020.spop)
	c:RegisterEffect(e1)
end
function c45221020.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c45221020.filter(c,e,tp,lv)
	return c:IsType(TYPE_NORMAL) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c45221020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=math.min(3,Duel.GetMatchingGroupCount(c45221020.cfilter,tp,LOCATION_GRAVE,0,nil))
		return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c45221020.filter,tp,LOCATION_DECK,0,1,nil,e,tp,ct)
	end
	local cg=Duel.GetMatchingGroup(c45221020.cfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=math.min(3,cg:GetCount())
	local tg=Duel.GetMatchingGroup(c45221020.filter,tp,LOCATION_DECK,0,nil,e,tp,ct)
	local lvt={}
	local pc=1
	for i=1,3 do
		if tg:IsExists(c45221020.sfilter,1,nil,i,e,tp) then lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(45221020,1))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=cg:Select(tp,lv,lv,nil)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
	Duel.SetTargetParam(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c45221020.sfilter(c,lv,e,tp)
	return c:IsType(TYPE_NORMAL) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c45221020.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c45221020.sfilter,tp,LOCATION_DECK,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
