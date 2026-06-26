--妖精の伝姫
function c91957038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Normal Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_MSET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,91957038)
	e2:SetCost(c91957038.nscost)
	e2:SetTarget(c91957038.nstg)
	e2:SetOperation(c91957038.nsop)
	c:RegisterEffect(e2)
	--Avoid Damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c91957038.damval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e4:SetCondition(c91957038.damcon)
	c:RegisterEffect(e4)
end
function c91957038.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c91957038.nsfilter(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttack(1850) and not c:IsPublic() and c:IsSummonable(true,nil)
		and not Duel.IsExistingMatchingCard(c91957038.cfilter,tp,LOCATION_MZONE,0,1,nil,c:GetCode())
end
function c91957038.nscost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.IsExistingMatchingCard(c91957038.nsfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c91957038.nsfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabelObject(g:GetFirst())
end
function c91957038.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return true
	end
	Duel.SetTargetCard(e:GetLabelObject())
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c91957038.nsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if tc:IsSummonable(true,nil) and (not tc:IsMSetable(true,nil)
			or Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) then
			Duel.Summon(tp,tc,true,nil)
		else Duel.MSet(tp,tc,true,nil) end
	end
end
function c91957038.damfilter(c)
	return c:GetBaseAttack()==1850 and c:IsRace(RACE_SPELLCASTER) and c:IsFaceup()
end
function c91957038.damcon(e)
	return e:GetHandler():GetFlagEffect(91957038)==0
		and Duel.IsExistingMatchingCard(c91957038.damfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c91957038.damval(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and c91957038.damcon(e) then
		c:RegisterFlagEffect(91957038,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		return 0
	end
	return val
end
