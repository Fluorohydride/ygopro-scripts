--アップデートジャマー
function c88093706.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c88093706.mfilter,2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88093706,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c88093706.atkcon)
	e1:SetCost(c88093706.atkcost)
	e1:SetOperation(c88093706.atkop)
	c:RegisterEffect(e1)
	--be material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88093706,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c88093706.efcon)
	e2:SetTarget(c88093706.eftg)
	e2:SetOperation(c88093706.efop)
	c:RegisterEffect(e2)
	--reg
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c88093706.efcon)
	e3:SetOperation(c88093706.regop)
	c:RegisterEffect(e3)
end
function c88093706.mfilter(c)
	return c:IsLevelAbove(2) and c:IsLinkRace(RACE_CYBERSE)
end
function c88093706.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a:GetControler()==tp and a:IsRace(RACE_CYBERSE)
		or d and d:GetControler()==tp and d:IsRace(RACE_CYBERSE)
end
function c88093706.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(88093706)==0 end
	c:RegisterFlagEffect(88093706,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c88093706.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c88093706.distg)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c88093706.disop)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e3,tp)
	if a:IsRelateToBattle() then
		local aa=a:GetTextAttack()
		local ad=a:GetTextDefense()
		if a:IsImmuneToEffect(e) then
			aa=a:GetBaseAttack()
			ad=a:GetBaseDefense()
		end
		if aa<0 then aa=0 end
		if ad<0 then ad=0 end
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_SET_ATTACK_FINAL)
		e4:SetReset(RESET_PHASE+PHASE_DAMAGE)
		e4:SetValue(aa)
		a:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e5:SetReset(RESET_PHASE+PHASE_DAMAGE)
		e5:SetValue(ad)
		a:RegisterEffect(e5,true)
	end
	if d and d:IsRelateToBattle() then
		local da=d:GetTextAttack()
		local dd=d:GetTextDefense()
		if d:IsImmuneToEffect(e) then
			da=d:GetBaseAttack()
			dd=d:GetBaseDefense()
		end
		if da<0 then da=0 end
		if dd<0 then dd=0 end
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCode(EFFECT_SET_ATTACK_FINAL)
		e6:SetValue(da)
		e6:SetReset(RESET_PHASE+PHASE_DAMAGE)
		d:RegisterEffect(e6,true)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e7:SetRange(LOCATION_MZONE)
		e7:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e7:SetValue(dd)
		e7:SetReset(RESET_PHASE+PHASE_DAMAGE)
		d:RegisterEffect(e7,true)
	end
	if a:IsRelateToBattle() and d and d:IsRelateToBattle() then
		local g=Group.FromCards(a,d)
		g:KeepAlive()
		local e8=Effect.CreateEffect(c)
		e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e8:SetCode(EVENT_BATTLE_DESTROYING)
		e8:SetLabelObject(g)
		e8:SetOperation(c88093706.damop)
		e8:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e8,tp)
	end
end
function c88093706.distg(e,c)
	return c~=e:GetHandler()
end
function c88093706.disop(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if bit.band(loc,LOCATION_ONFIELD)~=0 then
		Duel.NegateEffect(ev)
	end
end
function c88093706.damfilter(c,p)
	return c:IsReason(REASON_BATTLE) and c:IsLocation(LOCATION_GRAVE) and c:IsControler(p)
end
function c88093706.damop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():IsExists(c88093706.damfilter,1,nil,1-tp) then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
function c88093706.efcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_LINK
end
function c88093706.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=e:GetHandler():GetReasonCard()
	if chk==0 then return rc:GetFlagEffect(88093706)~=0 and rc:GetFlagEffect(88093707)==0 end
	rc:RegisterFlagEffect(88093707,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c88093706.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if rc:GetFlagEffect(88093706)==0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88093706,2))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	rc:RegisterEffect(e1)
end
function c88093706.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	rc:RegisterFlagEffect(88093706,RESET_EVENT+RESETS_STANDARD,0,1)
end
