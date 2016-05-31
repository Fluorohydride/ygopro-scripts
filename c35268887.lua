--ダメージ・トランスレーション
function c35268887.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c35268887.activate)
	c:RegisterEffect(e1)
	if not c35268887.global_check then
		c35268887.global_check=true
		c35268887[0]=0
		c35268887[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c35268887.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c35268887.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c35268887.checkop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		c35268887[ep]=c35268887[ep]+1
	end
end
function c35268887.clear(e,tp,eg,ep,ev,re,r,rp)
	c35268887[0]=0
	c35268887[1]=0
end
function c35268887.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c35268887.val)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(35268887,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetTarget(c35268887.tokentg)
	e2:SetOperation(c35268887.tokenop)
	e2:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e2,tp)
end
function c35268887.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then
		return dam/2
	else return dam end
end
function c35268887.tokentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=c35268887[tp]
	if chk==0 then return ct>0 and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
		and Duel.IsPlayerCanSpecialSummonMonster(tp,35268888,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
end
function c35268887.tokenop(e,tp,eg,ep,ev,re,r,rp)
	local ct=c35268887[tp]
	if (ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133))
		or Duel.GetLocationCount(tp,LOCATION_MZONE)<ct
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,35268888,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
	for i=1,ct do
		local token=Duel.CreateToken(tp,35268888)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	Duel.SpecialSummonComplete()
end
