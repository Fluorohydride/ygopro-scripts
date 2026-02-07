--超逸融合
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
		and c:GetLevel()>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.spfilter(c,e,tp,tc)
	return c:IsAttribute(tc:GetAttribute())
		and c:IsRace(tc:GetRace())
		and c:GetLevel()>0
		and not c:IsLevel(tc:GetLevel())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	if e:IsCostChecked() and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.fspfilter(c,e,tp,mg,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and not mg:IsExists(Card.IsImmuneToEffect,1,nil,e)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg,nil,chkf)
end
function s.ffilter(c,mg)
	return mg:IsContains(c)
end
function s.fcheck(mg)
	return function(tp,sg,fc)
				return sg:IsExists(s.ffilter,2,nil,mg)
			end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
		if not g or g:GetCount()==0 then return end
		local fc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(fc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			fc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			fc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
			local chkf=tp
			local mg=Group.FromCards(tc,fc)
			aux.FCheckAdditional=s.fcheck
			local sg=Duel.GetMatchingGroup(s.fspfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
			local b1=sg:GetCount()>0
			local b2=fc:IsAbleToGrave()
			local op=aux.SelectFromOptions(tp,
				{b1,aux.Stringid(id,1),1},
				{b2,aux.Stringid(id,2),2})
			Duel.BreakEffect()
			if op==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:Select(tp,1,1,nil)
				local tfc=tg:GetFirst()
				local mat=Duel.SelectFusionMaterial(tp,tfc,mg,nil,chkf)
				tfc:SetMaterial(mat)
				Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tfc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
				tfc:CompleteProcedure()
			elseif op==2 then
				Duel.SendtoGrave(fc,REASON_EFFECT)
			end
		end
	end
end
