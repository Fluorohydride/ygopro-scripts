--融合呪印生物－闇
function c52101615.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(52101615,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabel(0)
	e1:SetCost(c52101615.cost)
	e1:SetTarget(c52101615.target)
	e1:SetOperation(c52101615.operation)
	c:RegisterEffect(e1)
	--fusion substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e2:SetCondition(c52101615.subcon)
	c:RegisterEffect(e2)
end
function c52101615.subcon(e)
	return e:GetHandler():IsLocation(0x1e)
end
function c52101615.filter(c,e,tp,m,gc,chkf)
	if not (c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end
	Auxiliary.FCheckAdditional=c52101615.fccheck(#m)
	local res=c:CheckFusionMaterial(m,gc,chkf)
	Auxiliary.FCheckAdditional=nil
	return res
end
function c52101615.fccheck(ct)
	return function(tp,sg,fc)
		return #sg==ct
	end
end
function c52101615.mfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsCanBeFusionMaterial() and (c:IsControler(tp) or c:IsFaceup())
end
function c52101615.fselect(c,tp,rg,sg,e,gc,chkf)
	sg:AddCard(c)
	local res=c52101615.fgoal(tp,sg,e,gc,chkf) or rg:IsExists(c52101615.fselect,1,sg,tp,rg,sg,e,gc,chkf)
	sg:RemoveCard(c)
	return res
end
function c52101615.fgoal(tp,sg,e,gc,chkf)
	if sg:GetCount()>0 then
		if not Duel.IsExistingMatchingCard(c52101615.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg,gc,chkf) then return false end
		Duel.SetSelectedCard(sg)
		return Duel.CheckReleaseGroup(tp,nil,0,nil)
	else return false end
end
function c52101615.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c52101615.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local chkf=tp+0x100
	local g=Group.FromCards(c)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		local mg=Duel.GetReleaseGroup(tp):Filter(c52101615.mfilter,nil,tp)
		return mg:IsExists(c52101615.fselect,1,c,tp,mg,g,e,c,chkf)
	end
	local mg=Duel.GetReleaseGroup(tp):Filter(c52101615.mfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	while true do
		local rg=mg:Filter(c52101615.fselect,g,tp,mg,g,e,c,chkf)
		if #rg==0 then break end
		local min=1
		if c52101615.fgoal(tp,g,e,c,chkf) then min=0 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=rg:FilterSelect(tp,c52101615.fselect,1,1,g,tp,rg,g,e,c,chkf)
		if #sg==0 then break end
		g:Merge(sg)
	end
	local fg=Duel.SelectMatchingCard(tp,c52101615.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g,c,chkf)
	Duel.Release(g,REASON_COST)
	e:SetLabel(fg:GetFirst():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c52101615.filter2(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c52101615.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local code=e:GetLabel()
	local tc=Duel.GetFirstMatchingCard(c52101615.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,code)
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
