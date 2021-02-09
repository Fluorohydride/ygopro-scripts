--融合呪印生物－光
function c15717011.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(15717011,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabel(0)
	e1:SetCost(c15717011.cost)
	e1:SetTarget(c15717011.target)
	e1:SetOperation(c15717011.operation)
	c:RegisterEffect(e1)
	--fusion substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e2:SetCondition(c15717011.subcon)
	c:RegisterEffect(e2)
end
function c15717011.subcon(e)
	return e:GetHandler():IsLocation(0x1e)
end
function c15717011.filter(c,e,tp,m,gc,chkf)
	return c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_LIGHT)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function c15717011.mfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsCanBeFusionMaterial() and (c:IsControler(tp) or c:IsFaceup())
end
function c15717011.fcheck(tp,sg,fc)
	return Duel.CheckReleaseGroup(tp,Auxiliary.IsInGroup,#sg,nil,sg)
end
function c15717011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c15717011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local chkf=tp+0x100
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		local mg=Duel.GetReleaseGroup(tp):Filter(c15717011.mfilter,nil,tp)
		Auxiliary.FCheckAdditional=c15717011.fcheck
		if c59160188 then c59160188.re_activated=true end
		local res=Duel.IsExistingMatchingCard(c15717011.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,c,chkf)
		Auxiliary.FCheckAdditional=nil
		if c59160188 then c59160188.re_activated=false end
		return res
	end
	local mg=Duel.GetReleaseGroup(tp):Filter(c15717011.mfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Auxiliary.FCheckAdditional=c15717011.fcheck
	if c59160188 then c59160188.re_activated=true end
	local g=Duel.SelectMatchingCard(tp,c15717011.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg,c,chkf)
	local mat=Duel.SelectFusionMaterial(tp,g:GetFirst(),mg,c,chkf)
	Auxiliary.FCheckAdditional=nil
	if c59160188 then c59160188.re_activated=false end
	aux.UseExtraReleaseCount(mat,tp)
	Duel.Release(mat,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c15717011.filter2(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c15717011.operation(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local tc=Duel.GetFirstMatchingCard(c15717011.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,code)
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
