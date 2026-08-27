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
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
		if not g or g:GetCount()==0 then return end
		local fc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(fc,0,tp,tp,false,false,POS_FACEUP) then
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
			local material_group=Group.FromCards(tc,fc)
			local function matfilter(material,effect,player)
				return material_group:IsContains(material)
			end
			local function gcheck(tp,mg,fc,mg_all,effect)
				return mg_all and #mg_all==#material_group
			end
			local fusion_effect=FusionSpell.CreateSummonEffect(c,{
				pre_select_mat_location=LOCATION_MZONE,
				pre_select_mat_opponent_location=LOCATION_MZONE,
				matfilter=matfilter,
				additional_fgoalcheck=gcheck
			})
			local b1=fusion_effect:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0)
			local b2=fc:IsAbleToGrave()
			local op=aux.SelectFromOptions(tp,
				{b1,aux.Stringid(id,1),1},
				{b2,aux.Stringid(id,2),2})
			Duel.BreakEffect()
			if op==1 then
				Duel.HintSelection(material_group)
				fusion_effect:GetOperation()(e,tp,eg,ep,ev,re,r,rp)
			elseif op==2 then
				Duel.SendtoGrave(fc,REASON_EFFECT)
			end
		end
	end
end
