--ナンバーズ・エヴァイユ
function c20994205.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c20994205.condition)
	e1:SetTarget(c20994205.target)
	e1:SetOperation(c20994205.activate)
	c:RegisterEffect(e1)
end
function c20994205.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c20994205.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c20994205.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c20994205.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c20994205.nofilter(c)
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local no=m.xyz_number
	return no
end
function c20994205.spfilter(c,e,tp)
	if not c20994205.nofilter(c) then return end
	local g=Duel.GetMatchingGroup(c20994205.nofilter,tp,LOCATION_EXTRA,0,c)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and g:CheckSubGroup(c20994205.fselect,4,4,c)
end
function c20994205.fselect(sg,c)
	return sg:GetSum(c20994205.nofilter)==c.xyz_number and sg:GetClassCount(Card.GetRank)==4
		and sg:Filter(Card.IsCanBeXyzMaterial,nil,c):GetCount()==4
end
function c20994205.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20994205.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c20994205.gselect(sg,e,tp)
	local g=Duel.GetMatchingGroup(c20994205.nofilter,tp,LOCATION_EXTRA,0,sg)
	return g:IsExists(c20994205.spfilter2,1,nil,sg,e,tp)
end
function c20994205.spfilter2(c,sg,e,tp)
	return sg:GetSum(c20994205.nofilter)==c.xyz_number and sg:GetClassCount(Card.GetRank)==4
		and sg:Filter(Card.IsCanBeXyzMaterial,nil,c):GetCount()==4
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c20994205.activate(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	local g=Duel.GetMatchingGroup(c20994205.nofilter,tp,LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:SelectSubGroup(tp,c20994205.gselect,false,4,4,e,tp)
	if sg then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=g:Filter(c20994205.spfilter2,sg,sg,e,tp):Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(xyz,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		Duel.Overlay(xyz,sg)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetCondition(c20994205.splimitcon)
		e1:SetTarget(c20994205.splimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		xyz:RegisterEffect(e1,true)
	end
end
function c20994205.splimitcon(e)
	return e:GetHandler():IsControler(e:GetOwnerPlayer())
end
function c20994205.splimit(e,c)
	return not c20994205.nofilter(c)
end
