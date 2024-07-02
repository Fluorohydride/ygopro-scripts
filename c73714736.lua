--Flame Swordsrealm
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,45231177)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.limcon)
	e3:SetOperation(s.limop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_CHAIN_END)
	e4:SetOperation(s.limop2)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.atktg)
	e5:SetOperation(s.atkop)
	c:RegisterEffect(e5)
end
function s.cfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.filter(c,e,tp,mc)
	return c:IsType(TYPE_FUSION) and c:IsCode(45231177) and c:CheckFusionMaterial()
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==100 then return true end
		e:SetLabel(0)
		return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
			and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
	local tc=g:GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	tc:CompleteProcedure()
end
function s.limfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsRace(RACE_WARRIOR)
end
function s.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.limfilter,1,nil,tp)
end
function s.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(s.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(s.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(id)
	e:Reset()
end
function s.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(id)~=0 then
		Duel.SetChainLimitTillChainEnd(s.chainlm)
	end
	e:GetHandler():ResetFlagEffect(id)
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() and chkc:IsRace(RACE_WARRIOR) end
	if chk==0 then return Duel.IsExistingTarget(aux.AND(Card.IsRace,Card.IsFaceup),tp,LOCATION_MZONE,0,1,nil,RACE_WARRIOR) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.AND(Card.IsRace,Card.IsFaceup),tp,LOCATION_MZONE,0,1,1,nil,RACE_WARRIOR)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if not tc:IsHasEffect(EFFECT_REVERSE_UPDATE) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetTargetRange(LOCATION_MZONE,0)
			e2:SetTarget(s.atkfilter)
			e2:SetLabel(tc:GetFieldID())
			e2:SetValue(1000)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function s.atkfilter(e,c)
	return e:GetLabel()~=c:GetFieldID()
end