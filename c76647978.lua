--超越融合
function c76647978.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		mat_location=LOCATION_MZONE,
		fcheck=c76647978.fcheck,
		gcheck=c76647978.gcheck,
		foperation=c76647978.fop
	})
	e1:SetDescription(aux.Stringid(76647978,0))
	e1:SetCost(c76647978.cost)
	--Summon Materials
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76647978,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c76647978.sptg)
	e2:SetOperation(c76647978.spop)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end
function c76647978.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c76647978.fcheck(tp,sg,fc)
	return #sg<=2
end
function c76647978.gcheck(sg)
	return #sg<=2
end
function c76647978.fop(e,tp,tc)
	tc:RegisterFlagEffect(76647978,RESET_EVENT+RESETS_STANDARD,0,1)
	tc:CompleteProcedure()
	local e1=e:GetLabelObject()
	if e1 then e1:SetLabelObject(tc) end
end
function c76647978.mgfilter(c,e,tp,fusc,mg)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x40008)==0x40008 and c:GetReasonCard()==fusc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and fusc:CheckFusionMaterial(mg,c,PLAYER_NONE,true)
end
function c76647978.spfilter(c,e,tp)
	if c:IsFaceup() and c:GetFlagEffect(76647978)~=0 and c==e:GetLabelObject() then
		local mg=c:GetMaterial()
		local ct=mg:GetCount()
		return ct>0 and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
			and mg:FilterCount(c76647978.mgfilter,nil,e,tp,c,mg)==ct
			and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	else return false end
end
function c76647978.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c76647978.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c76647978.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c76647978.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c76647978.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetMaterial()
	local ct=mg:GetCount()
	if ct>0 and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and mg:FilterCount(c76647978.mgfilter,nil,e,tp,tc,mg)==ct
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		local sc=mg:GetFirst()
		while sc do
			if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e2,true)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_SET_ATTACK_FINAL)
				e3:SetValue(0)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
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
