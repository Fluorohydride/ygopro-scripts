--電磁石の戦士マグネット・ベルセリオン
function c42901635.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c42901635.spcon)
	e1:SetOperation(c42901635.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c42901635.cost)
	e2:SetTarget(c42901635.target)
	e2:SetOperation(c42901635.activate)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCondition(c42901635.spcon2)
	e3:SetTarget(c42901635.sptg2)
	e3:SetOperation(c42901635.spop2)
	c:RegisterEffect(e3)
end
function c42901635.spcostfilter(c)
	return (c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) or c:IsFaceup())
		and c:IsAbleToRemoveAsCost() and c:IsCode(42023223,79418928,15502037)
end
c42901635.spcost_list={42023223,79418928,15502037}
function c42901635.spcost_selector(c,tp,g,sg,i)
	if not c:IsCode(c42901635.spcost_list[i]) then return false end
	sg:AddCard(c)
	g:RemoveCard(c)
	local flag=false
	if i<3 then
		flag=g:IsExists(c42901635.spcost_selector,1,nil,tp,g,sg,i+1)
	else
		flag=Duel.GetMZoneCount(tp,sg,tp)>0
	end
	sg:RemoveCard(c)
	g:AddCard(c)
	return flag
end
function c42901635.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c42901635.spcostfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local sg=Group.CreateGroup()
	return g:IsExists(c42901635.spcost_selector,1,nil,tp,g,sg,1)
end
function c42901635.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c42901635.spcostfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local sg=Group.CreateGroup()
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=g:FilterSelect(tp,c42901635.spcost_selector,1,1,nil,tp,g,sg,i)
		sg:Merge(g1)
		g:Sub(g1)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c42901635.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2066) and c:IsLevelBelow(4) and c:IsAbleToRemoveAsCost()
end
function c42901635.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c42901635.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c42901635.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c42901635.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c42901635.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c42901635.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE)
		or (rp==1-tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp)
end
function c42901635.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(42023223,79418928,15502037)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsCanBeEffectTarget(e)
end
function c42901635.sptarget_selector(c,tp,g,sg,i)
	if not c:IsCode(c42901635.spcost_list[i]) then return false end
	if i<3 then
		sg:AddCard(c)
		g:RemoveCard(c)
		local flag=g:IsExists(c42901635.sptarget_selector,1,nil,tp,g,sg,i+1)
		sg:RemoveCard(c)
		g:AddCard(c)
		return flag
	else
		return true
	end
end
function c42901635.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c42901635.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
	local sg=Group.CreateGroup()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and g:IsExists(c42901635.sptarget_selector,1,nil,tp,g,sg,1) end
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=g:FilterSelect(tp,c42901635.sptarget_selector,1,1,nil,tp,g,sg,i)
		sg:Merge(g1)
		g:Sub(g1)
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,3,0,0)
end
function c42901635.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 or g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if g:GetCount()<=ft then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ft,ft,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		g:Sub(sg)
		Duel.SendtoGrave(g,REASON_RULE)
	end
end
