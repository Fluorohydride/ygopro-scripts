--影装騎士 ブラック・ジャック
local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro summon
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
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.eqcon)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.adval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--self destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetCondition(s.descon)
	c:RegisterEffect(e5)
end
function s.desfilter(c,tp)
	return c:IsLocation(LOCATION_SZONE) and c:IsControler(1-tp) and c:GetSequence()<5
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.desfilter,1,e:GetHandler(),tp)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,LOCATION_DECK)
end
function s.eqfilter(c,tc,tp)
	return c:IsType(TYPE_MONSTER)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function s.confirm_decktop_s(tp,count)
	local max_decktop=5
	if count>max_decktop then
		local g=Duel.GetDecktopGroup(tp,count)
		Duel.ConfirmCards(1-tp,g)
	else
		Duel.ConfirmDecktop(tp,count)
	end
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER)
	if mg:GetCount()==0 or Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local seq=-1
	local tc=mg:GetFirst()
	local qc=nil
	while tc do
		if tc:GetSequence()>seq then
			seq=tc:GetSequence()
			qc=tc
		end
		tc=mg:GetNext()
	end
	if seq==-1 then
		return
	end
	s.confirm_decktop_s(tp,dcount-seq)
	local cg=Duel.GetDecktopGroup(tp,dcount-seq-1)
	if c:IsRelateToChain() and c:IsFaceup() and qc then
		Duel.DisableShuffleCheck()
		if s.eqfilter(qc,c,tp) then
			if Duel.Equip(tp,qc,c) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetLabelObject(c)
				e1:SetValue(s.eqlimit)
				qc:RegisterEffect(e1)
			end
		else
			Duel.SendtoGrave(qc,REASON_RULE)
		end
	elseif qc then
		Duel.SendtoGrave(qc,REASON_RULE)
	end
	if #cg>0 then
		Duel.SortDecktop(tp,tp,#cg)
		for i=1,#cg do
			local mvg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mvg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function s.cqfilter(c)
	return c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
end
function s.adval(e,c)
	local eg=c:GetEquipGroup():Filter(s.cqfilter,nil)
	return eg:GetSum(Card.GetOriginalLevel)*300
end
function s.descon(e)
	local eg=e:GetHandler():GetEquipGroup():Filter(s.cqfilter,nil)
	return eg:GetSum(Card.GetOriginalLevel)>21
end
