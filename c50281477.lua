--Tainted of the Tistina
local s,id,o=GetID()
function s.initial_effect(c)
	--tribute opponent 1 facedown monster for advance summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.otcon)
	e1:SetOperation(s.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--level change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_COST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(s.lvop)
	c:RegisterEffect(e2)
	--double attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(s.dacon)
	e3:SetTarget(s.datg)
	e3:SetOperation(s.daop)
	c:RegisterEffect(e3)
end
function s.tfilter(c,tp)
	return c:IsFacedown() and c:IsControler(1-tp)
end
function s.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,0,LOCATION_MZONE,nil)
	return minc<=1 and g:IsExists(s.tfilter,1,nil,tp) and Duel.GetMZoneCount(tp)>0
end
function s.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetMatchingGroup(Card.IsReleasable,tp,0,LOCATION_MZONE,nil)
	local g2=g1:Filter(s.tfilter,nil,tp)
	local sg=g2:Select(tp,1,1,nil)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_MATERIAL+REASON_SUMMON)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(10)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function s.dacon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1a4) and c:IsCanBeEffectTarget() and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function s.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.filter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return aux.bpcon(e,tp,eg,ep,ev,re,r,rp) and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		--check
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EVENT_ATTACK_ANNOUNCE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetOperation(s.checkop)
		Duel.RegisterEffect(e2,tp)
		--cannot announce
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetCondition(s.atkcon)
		e3:SetTarget(s.atktg)
		e2:SetLabelObject(e3)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local fid=eg:GetFirst():GetFieldID()
	e:GetLabelObject():SetLabel(fid)
end
function s.atkcon(e)
	return e:GetLabel()~=0
end
function s.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
