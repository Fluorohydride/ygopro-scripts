--ナンバーズ・エヴァイユ
---@param c Card
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
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x48) and aux.GetXyzNumber(c)
end
function c20994205.spfilter(c,e,tp)
	return c20994205.nofilter(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c20994205.gselect(g,spg)
	return spg:IsExists(c20994205.spnofilter,1,g,g:GetSum(aux.GetXyzNumber))
end
function c20994205.spnofilter(c,sum)
	return aux.GetXyzNumber(c)==sum
end
function c20994205.gcheck(max)
	return	function(g)
				return g:GetClassCount(Card.GetRank)==#g and g:GetSum(aux.GetXyzNumber)<=max
			end
end
function c20994205.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) then return false end
		local mg=Duel.GetMatchingGroup(c20994205.nofilter,tp,LOCATION_EXTRA,0,nil)
		local spg=Duel.GetMatchingGroup(c20994205.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if #mg<5 or #spg==0 then return false end
		local _,max=spg:GetMaxGroup(aux.GetXyzNumber)
		aux.GCheckAdditional=c20994205.gcheck(max)
		local res=mg:CheckSubGroup(c20994205.gselect,4,4,spg)
		aux.GCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c20994205.activate(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	local mg=Duel.GetMatchingGroup(c20994205.nofilter,tp,LOCATION_EXTRA,0,nil)
	local spg=Duel.GetMatchingGroup(c20994205.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if #mg<5 or #spg==0 then return end
	local _,max=spg:GetMaxGroup(aux.GetXyzNumber)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	aux.GCheckAdditional=c20994205.gcheck(max)
	local sg=mg:SelectSubGroup(tp,c20994205.gselect,false,4,4,spg)
	aux.GCheckAdditional=nil
	if sg then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=spg:FilterSelect(tp,c20994205.spnofilter,1,1,sg,sg:GetSum(aux.GetXyzNumber)):GetFirst()
		xyz:SetMaterial(nil)
		Duel.SpecialSummon(xyz,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		xyz:CompleteProcedure()
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
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(63060238)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetAbsoluteRange(tp,1,0)
		e2:SetCondition(c20994205.splimitcon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		xyz:RegisterEffect(e2,true)
	end
end
function c20994205.splimitcon(e)
	return e:GetHandler():IsControler(e:GetOwnerPlayer())
end
function c20994205.splimit(e,c)
	return not c20994205.nofilter(c)
end
