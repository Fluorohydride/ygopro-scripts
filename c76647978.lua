--超越融合
function c76647978.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76647978,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c76647978.cost)
	e1:SetTarget(c76647978.target)
	e1:SetOperation(c76647978.activate)
	c:RegisterEffect(e1)
	--Summon Materials
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76647978,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c76647978.spcost)
	e2:SetTarget(c76647978.sptg)
	e2:SetOperation(c76647978.spop)
	c:RegisterEffect(e2)
end
function c76647978.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c76647978.filter0(c,e,tp,mg)
	return mg:IsExists(c76647978.filter1,1,nil,e,tp,c)
end
function c76647978.filter1(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	return Duel.IsExistingMatchingCard(c76647978.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
end
function c76647978.filter2(c,e,tp,mg)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg,nil)
end
function c76647978.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and mg:IsExists(c76647978.filter0,1,nil,e,tp,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c76647978.filter3(c,e,tp,mg)
	return not c:IsImmuneToEffect(e) and mg:IsExists(c76647978.filter4,1,c,e,tp,c)
end
function c76647978.filter4(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	return not c:IsImmuneToEffect(e) and Duel.IsExistingMatchingCard(c76647978.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
end
function c76647978.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return end
	local mg=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=mg:FilterSelect(tp,c76647978.filter3,1,1,nil,e,tp,mg)
	if g1:GetCount()==0 then return end
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=mg:FilterSelect(tp,c76647978.filter4,1,1,tc1,e,tp,tc1)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c76647978.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g1)
	local tc=sg:GetFirst()
	tc:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_FUSION+REASON_EFFECT)
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	tc:RegisterFlagEffect(76647978,RESET_EVENT+0x1fe0000,0,1)
	tc:CompleteProcedure()
end
function c76647978.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c76647978.mgfilter(c,e,tp,fusc,mg)
	return not c:IsControler(tp) or not c:IsLocation(LOCATION_GRAVE)
		or bit.band(c:GetReason(),0x40008)~=0x40008 or c:GetReasonCard()~=fusc
		or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsHasEffect(EFFECT_NECRO_VALLEY)
		or not fusc:CheckFusionMaterial(mg,c)
end
function c76647978.spfilter(c,e,tp,lc)
	if c:IsFaceup() and c:GetFlagEffect(76647978)~=0 then
		local mg=c:GetMaterial()
		return mg:GetCount()>0 and mg:GetCount()<=lc
			and not mg:IsExists(c76647978.mgfilter,1,nil,e,tp,c,mg)
			and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	else return false end
end
function c76647978.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c76647978.spfilter(chkc,e,tp,lc) end
	if chk==0 then return Duel.IsExistingTarget(c76647978.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,lc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c76647978.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,lc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c76647978.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetMaterial()
	if mg:GetCount()>0 and mg:GetCount()<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and not mg:IsExists(c76647978.mgfilter,1,nil,e,tp,tc) and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		local sc=mg:GetFirst()
		while sc do
			if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				sc:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				sc:RegisterEffect(e2,true)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_SET_ATTACK_FINAL)
				e3:SetValue(0)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				sc:RegisterEffect(e3,true)
				local e4=e3:Clone()
				e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
				sc:RegisterEffect(e4,true)
			end
			sc=mg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
