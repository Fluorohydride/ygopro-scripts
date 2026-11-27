--時械神祖ヴルガータ
function c67508932.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	--banish
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67508932,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCondition(c67508932.rmcond)
	e4:SetTarget(c67508932.rmtg)
	e4:SetOperation(c67508932.rmop)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(67508932,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c67508932.spcon)
	e5:SetTarget(c67508932.sptg)
	e5:SetOperation(c67508932.spop)
	c:RegisterEffect(e5)
end
function c67508932.rmcond(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return aux.dsercon(e,tp,eg,ep,ev,re,r,rp) and c:IsSummonLocation(LOCATION_EXTRA) and c:GetBattledGroupCount()>0
end
function c67508932.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,1-tp,LOCATION_MZONE)
end
function c67508932.rfilter(c)
	return not c:IsReason(REASON_REDIRECT)
end
function c67508932.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		local rg=og:Filter(c67508932.rfilter,nil)
		if #rg>0 then
			local lab=0
			if c:GetFlagEffect(67508933)==0 then
				lab=c:GetFieldID()
				c:RegisterFlagEffect(67508933,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,lab)
			else
				lab=c:GetFlagEffectLabel(67508933)
			end
			for oc in aux.Next(rg) do
				oc:RegisterFlagEffect(67508932,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,lab)
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(HALF_DAMAGE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c67508932.spfilter(c,e,tp)
	local lab=c:GetFlagEffectLabel(67508932)
	return lab and lab==e:GetHandler():GetFlagEffectLabel(67508933)
		and c:GetReasonPlayer()==tp
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c67508932.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(67508933)>0
end
function c67508932.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c67508932.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,tp,LOCATION_REMOVED)
end
function c67508932.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c67508932.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,e,tp)
	if ft<=0 or #tg==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)
	end
end
