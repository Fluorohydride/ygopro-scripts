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
function c15574615.spcostfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
		and c:IsCode(80208158,16796157,43791861,79185500)
end
c15574615.spcost_list={80208158,16796157,43791861,79185500}
function c15574615.spcost_selector(c,tp,g,sg,i)
	if not c:IsCode(c15574615.spcost_list[i]) then return false end
	sg:AddCard(c)
	g:RemoveCard(c)
	local flag=false
	if i<4 then
		flag=g:IsExists(c15574615.spcost_selector,1,nil,tp,g,sg,i+1)
	else
		flag=Duel.GetMZoneCount(tp,sg,tp)>0
	end
	sg:RemoveCard(c)
	g:AddCard(c)
	return flag
end
function c15574615.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c15574615.spcostfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local sg=Group.CreateGroup()
	return g:IsExists(c15574615.spcost_selector,1,nil,tp,g,sg,1)
end
function c15574615.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c15574615.spcostfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local sg=Group.CreateGroup()
	for i=1,4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=g:FilterSelect(tp,c15574615.spcost_selector,1,1,nil,tp,g,sg,i)
		sg:Merge(g1)
		g:Sub(g1)
	end
	Duel.SendtoGrave(sg,REASON_COST)
end
function c15574615.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c15574615.spfilter(c,e,tp)
	return c:IsCode(80208158,16796157,43791861,79185500) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c15574615.sptarget_selector(c,tp,g,sg,i)
	if not c:IsCode(c15574615.spcost_list[i]) then return false end
	if i<4 then
		sg:AddCard(c)
		g:RemoveCard(c)
		local flag=g:IsExists(c4335427.sptarget_selector,1,nil,tp,g,sg,i+1)
		sg:RemoveCard(c)
		g:AddCard(c)
		return flag
	else
		return true
	end
end
function c15574615.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c15574615.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local sg=Group.CreateGroup()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=3
		and g:IsExists(c15574615.sptarget_selector,1,nil,tp,g,sg,1)
	end
	for i=1,4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=g:FilterSelect(tp,c15574615.sptarget_selector,1,1,nil,tp,g,sg,i)
		sg:Merge(g1)
		g:Sub(g1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,4,0,0)
end
function c15574615.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if g:GetCount()>ft then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
