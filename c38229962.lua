--Giant Beetrooper Invincible Atlas
--scripted by RayeHikawa
function c38229962.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_INSECT),2)
	--cannot target & indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetCondition(c38229962.condition)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c38229962.splimit)
	c:RegisterEffect(e3)
	--choose effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,38229962)
	e4:SetCost(c38229962.effcost)
	e4:SetTarget(c38229962.efftg)
	e4:SetOperation(c38229962.effop)
	c:RegisterEffect(e4)
end
--cannot target & indes
function c38229962.condition(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:IsAttackBelow(3000)
end
--splimit
function c38229962.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_INSECT)
end
--choose effect
function c38229962.costfilter(c)
	return c:IsRace(RACE_INSECT)
end
function c38229962.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c38229962.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c38229962.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c38229962.spfilter(c,e,tp)
	return c:IsSetCard(SET_BEETROOPER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c38229962.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c38229962.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local b2=e:GetHandler():GetFlagEffect(38229962)==0 end
	if chk==0 then return b1 or b2 end
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(38229962,0)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(38229962,1)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_ATKCHANGE)
	end
end
function c38229962.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c38229962.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			c:RegisterFlagEffect(38229962,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(2000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end
