--超戦士の萌芽
function c45948430.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,45948430+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c45948430.target)
	e1:SetOperation(c45948430.activate)
	c:RegisterEffect(e1)
end
function c45948430.filter(c,e,tp,mg)
	if not c:IsSetCard(0x10cf) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local g=mg:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then
		g=g:Filter(c.mat_filter,nil)
	end
	return g:GetCount()>0
end
function c45948430.matfilter1(c,tp)
	local lv=c:GetLevel()
	return lv>0 and lv<8 and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c45948430.matfilter2,tp,LOCATION_DECK,0,1,c,lv,c:GetAttribute())
end
function c45948430.matfilter2(c,lv,att)
	return ((c:IsAttribute(ATTRIBUTE_LIGHT) and att==ATTRIBUTE_DARK) or (c:IsAttribute(ATTRIBUTE_DARK) and att==ATTRIBUTE_LIGHT))
		and c:GetLevel()==8-lv and c:IsAbleToGrave()
end
function c45948430.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c45948430.matfilter1,tp,LOCATION_HAND,0,nil,tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c45948430.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c45948430.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c45948430.matfilter1,tp,LOCATION_HAND,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c45948430.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	local tc1=tg:GetFirst()
	if tc1 then
		if tc1:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.IsChainDisablable(0) then
			Duel.NegateEffect(0)
			return
		end
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc1.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mat=Duel.SelectMatchingCard(tp,c45948430.matfilter1,tp,LOCATION_HAND,0,1,1,nil,tp)
		local tc2=mat:GetFirst()
		if not tc2 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mat2=Duel.SelectMatchingCard(tp,c45948430.matfilter2,tp,LOCATION_DECK,0,1,1,nil,tc2:GetLevel(),tc2:GetAttribute())
		mat:Merge(mat2)
		tc1:SetMaterial(mat)
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc1,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc1:CompleteProcedure()
	end
end
