--竜魔導の降霊師
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_FUSION_SUMMON+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.codetg)
	e1:SetOperation(s.codeop)
	c:RegisterEffect(e1)
end
function s.filter1(c,tp,ec)
	return c:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_GRAVE,0,1,nil,c,ec)
end
function s.filter2(c,fc,ec)
	return aux.IsCodeListed(fc,c:GetCode()) and not c:IsType(TYPE_FUSION) and c:IsType(TYPE_MONSTER)
		and not c:IsCode(ec:GetCode())
end
function s.codetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA,0,1,nil,tp,e:GetHandler()) end
end
function s.mfilter1(c,e)
	return c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function s.mfilter2(c,e)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function s.regeff(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.codeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToChain() then
		s.regeff(e,tp)
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_EXTRA,0,1,1,nil,tp,c)
	if cg:GetCount()==0 then
		s.regeff(e,tp)
		return
	end
	Duel.ConfirmCards(1-tp,cg)
	local fc=cg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil,fc,c)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(tc:GetCode())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,2))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetLabelObject(e1)
		e2:SetOperation(s.rstop)
		c:RegisterEffect(e2)
		Duel.AdjustAll()
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(s.mfilter1,nil,e)
		local mg2=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.mfilter2),tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		local res1=fc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and fc:CheckFusionMaterial(mg1,nil,chkf)
		local mg3=nil
		local res2=false
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res2=fc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and mf(fc) and fc:CheckFusionMaterial(mg3,nil,chkf)
		end
		if (res1 or res2) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			if res1 and (not res2 or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,fc,mg1,nil,chkf)
				fc:SetMaterial(mat1)
				Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			elseif ce then
				local mat2=Duel.SelectFusionMaterial(tp,fc,mg3,nil,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,fc,mat2)
			end
			fc:CompleteProcedure()
		end
	end
	s.regeff(e,tp)
end
function s.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.splimit(e,c)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
