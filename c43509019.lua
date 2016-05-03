--トゥーン・ディフェンス
function c43509019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c43509019.target)
	c:RegisterEffect(e1)
	--change battle target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43509019,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c43509019.cbcon)
	e2:SetTarget(c43509019.cbtg)
	e2:SetOperation(c43509019.cbop)
	c:RegisterEffect(e2)
end
function c43509019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE)
	if res and c43509019.cbcon(e,tp,teg,tep,tev,tre,tr,trp)
		and c43509019.cbtg(e,tp,teg,tep,tev,tre,tr,trp,0)
		and Duel.SelectYesNo(tp,94) then
		e:SetOperation(c43509019.cbop)
	else
		e:SetOperation(nil)
	end
end
function c43509019.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local bt=Duel.GetAttackTarget()
	return bt and bt:IsFaceup() and bt:IsLevelBelow(4) and bt:IsType(TYPE_TOON) and bt:GetControler()==e:GetHandlerPlayer()
end
function c43509019.cbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.GetAttacker():IsHasEffect(EFFECT_CANNOT_DIRECT_ATTACK) end
end
function c43509019.cbop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.ChangeAttackTarget(nil)
end
