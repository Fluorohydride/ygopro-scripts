--異次元ジェット・アイアン号
function c15574615.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c15574615.spcon)
	e1:SetOperation(c15574615.spop)
	c:RegisterEffect(e1)
	--atk
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
function c15574615.spfilter1(c,code,tp)
	return c:IsFaceup() and c:IsCode(code) and c:IsControler(tp) and c:IsAbleToGraveAsCost()
end
function c15574615.spfilter2(c,code)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCode(code) and c:IsAbleToGraveAsCost()
end
function c15574615.spfilter3(c,tp)
	return (c:IsCode(80208158) or c:IsCode(16796157) or c:IsCode(43791861) or c:IsCode(79185500)) and c:IsControler(tp)
end
function c15574615.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ct=0
	if Duel.IsExistingMatchingCard(c15574615.spfilter1,tp,LOCATION_MZONE,0,1,nil,80208158,tp) then ct=ct-1 end
	if Duel.IsExistingMatchingCard(c15574615.spfilter1,tp,LOCATION_MZONE,0,1,nil,16796157,tp) then ct=ct-1 end
	if Duel.IsExistingMatchingCard(c15574615.spfilter1,tp,LOCATION_MZONE,0,1,nil,43791861,tp) then ct=ct-1 end
	if Duel.IsExistingMatchingCard(c15574615.spfilter1,tp,LOCATION_MZONE,0,1,nil,79185500,tp) then ct=ct-1 end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>ct
		and Duel.IsExistingMatchingCard(c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,80208158)
		and Duel.IsExistingMatchingCard(c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,16796157)
		and Duel.IsExistingMatchingCard(c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,43791861)
		and Duel.IsExistingMatchingCard(c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,79185500)
end
function c15574615.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=nil
	local g2=nil
	local g3=nil
	local g4=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g1=Duel.SelectMatchingCard(tp,c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,80208158)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g2=Duel.SelectMatchingCard(tp,c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,16796157)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g3=Duel.SelectMatchingCard(tp,c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,43791861)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g4=Duel.SelectMatchingCard(tp,c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,79185500)
		g1:Merge(g2)
		g1:Merge(g3)
		g1:Merge(g4)
	elseif ft==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g1=Duel.SelectReleaseGroup(tp,c15574615.spfilter3,1,1,nil,tp)
		if g1:GetFirst():IsCode(80208158) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			g2=Duel.SelectMatchingCard(tp,c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,16796157)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			g3=Duel.SelectMatchingCard(tp,c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,43791861)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			g4=Duel.SelectMatchingCard(tp,c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,79185500)
		elseif g1:GetFirst():IsCode(16796157) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			g2=Duel.SelectMatchingCard(tp,c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,80208158)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			g3=Duel.SelectMatchingCard(tp,c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,43791861)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			g4=Duel.SelectMatchingCard(tp,c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,79185500)
		elseif g1:GetFirst():IsCode(43791861) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			g2=Duel.SelectMatchingCard(tp,c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,80208158)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			g3=Duel.SelectMatchingCard(tp,c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,16796157)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			g4=Duel.SelectMatchingCard(tp,c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,79185500)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			g2=Duel.SelectMatchingCard(tp,c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,80208158)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			g3=Duel.SelectMatchingCard(tp,c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,16796157)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			g4=Duel.SelectMatchingCard(tp,c15574615.spfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,43791861)
		end
		g1:Merge(g2)
		g1:Merge(g3)
		g1:Merge(g4)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g1=Duel.SelectMatchingCard(tp,c15574615.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,80208158,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g2=Duel.SelectMatchingCard(tp,c15574615.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,16796157,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g3=Duel.SelectMatchingCard(tp,c15574615.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,43791861,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g4=Duel.SelectMatchingCard(tp,c15574615.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,79185500,tp)
		g1:Merge(g2)
		g1:Merge(g3)
		g1:Merge(g4)
	end
	Duel.SendtoGrave(g1,REASON_COST)
end
function c15574615.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c15574615.spfilter4(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c15574615.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=3
		and Duel.IsExistingTarget(c15574615.spfilter4,tp,LOCATION_GRAVE,0,1,nil,e,tp,80208158)
		and Duel.IsExistingTarget(c15574615.spfilter4,tp,LOCATION_GRAVE,0,1,nil,e,tp,16796157)
		and Duel.IsExistingTarget(c15574615.spfilter4,tp,LOCATION_GRAVE,0,1,nil,e,tp,43791861)
		and Duel.IsExistingTarget(c15574615.spfilter4,tp,LOCATION_GRAVE,0,1,nil,e,tp,79185500) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c15574615.spfilter4,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,80208158)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c15574615.spfilter4,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,16796157)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=Duel.SelectTarget(tp,c15574615.spfilter4,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,43791861)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g4=Duel.SelectTarget(tp,c15574615.spfilter4,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,79185500)
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,4,0,0)
end
function c15574615.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if g:GetCount()>ft then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
